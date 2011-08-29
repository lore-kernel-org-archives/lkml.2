Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1H2Onz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:43:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42109 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab1H2Onu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E5B221B.4080309@intel.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
 <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
 <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com>
 <4E571D66.1070302@intel.com> <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com>
 <4E5AE82E.6000807@intel.com> <CAG1a4rsyQ5Ox_5i7K9tZT5q3YAnwRiG4uPkAkyY8JUZUjDkHpQ@mail.gmail.com>
 <4E5B221B.4080309@intel.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Mon, 29 Aug 2011 10:43:18 -0400
Message-ID: <CAG1a4rv2EhRE6O_0MT5NMN1T=087AZs3kBgv3iBTMsMbOpU+vQ@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 1:22 AM, Huang Ying <ying.huang@intel.com> wrote:
> -ENOENT is returned for apei_exec_run(, ACPI_ERST_GET_ERROR_RANGE).
> That is there is no instructions for mandatory action
> ACPI_ERST_GET_ERROR_RANGE.  It should be a firmware bug, try raise it to
> firmware vendor?

Could you please advise me on how should I do that? Do I need to
report this issue to my motherboard vendor (which is Asus)? If yes
then should it be via the standard technical support channel (like
http://vip.asus.com/eservice/techserv.aspx) or something more special?


Thank you,
Pavel
