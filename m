Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0HQAxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:53:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55086 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0HQAxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:53:42 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69DDA1.6010901@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 09:53:53 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [0/4][Patch-next]ACPI, APEI bug fix
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For supporting APEI to work well, I make 4 patches for fixing some bugs.
    - the first and the second patch fixed the wrong checking for ERST and EINJ
      tables' header.
    - the third one fixed the wrong return value of acpi_pre_map.
    - the last one fixed the unsuitable usage of platform_data.


Jin Dongming (4):
      [Patch-next] ACPI, APEI, ERST Fix the wrong checking of Serialization Header's
      [Patch-next] ACPI, APEI, EINJ Fix the wrong checking of Injection Header's len
      [Patch-next] ACPI, APEI Fix the return value(==NULL) of acpi_pre_map always.
      [Patch-next] ACPI, APEI, HEST Fix the unsuitable usage of platform_data.

================
 drivers/acpi/apei/einj.c |   15 +++++++++------
 drivers/acpi/apei/erst.c |   13 ++++++++-----
 drivers/acpi/apei/ghes.c |    2 +-
 drivers/acpi/apei/hest.c |   19 ++++++++++++++-----
 drivers/acpi/atomicio.c  |    4 ++--
 include/acpi/actbl1.h    |   31 +++++++++++++++++++++++--------
 6 files changed, 57 insertions(+), 27 deletions(-)

