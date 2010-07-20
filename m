Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0GTHCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:02:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47803 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0GTHCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:02:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Jul 2010 15:57:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com
Subject: Re: [PATCH 2/8] v3 Add new phys_index properties
Message-Id: <20100720155745.de079d69.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451D92.6020406@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	<4C451D92.6020406@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 22:52:50 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the 'phys_index' properties of a memory block to include a
> 'start_phys_index' which is the same as the current 'phys_index' property.
> This also adds an 'end_phys_index' property to indicate the id of the
> last section in th memory block.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

No, please remain "phys_index" as it is. please don't rename it.
IMHO, just adding end_phys_index is better.
please avoid interface change AFAP.

Do you have a problem if phys_index means start_phys_index ?

Thanks,
-Kame

