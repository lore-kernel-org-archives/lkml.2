Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1F0EZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 00:25:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47622 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1F0EYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 00:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=meIzhV/kWGByYiPEWURje0Wl3Srw8vuPKF1zrl9g2xHtULoG8NtDZDTeQAxhDYtYZV
         dXlpx0XQq0r+LjgMkDrocNPXZn9qOBtqHDOI9NeN87ngboTO3jFgAaCmu5qhs6w1QDlN
         +LikGctyrLxmeTMlnYfMk7Rr+yyMCiUMjnOF4=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <BANLkTimQ55xBwzoxnSAKznG-GTHZ+LtShw@mail.gmail.com>
References: <1308751077.4846.1.camel@phoenix> <BANLkTimQ55xBwzoxnSAKznG-GTHZ+LtShw@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 27 Jun 2011 12:23:59 +0800
Message-ID: <BANLkTi=7HEnt_SZjPV+-NOrQX=+XLbBGNg@mail.gmail.com>
Subject: Re: [PATCH] spi: omap2-mcspi: fix omap2_mcspi_probe error handling
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Juha Yrjola <juha.yrjola@nokia.com>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/22 Grant Likely <grant.likely@secretlab.ca>:
> On Wed, Jun 22, 2011 at 7:57 AM, Axel Lin <axel.lin@gmail.com> wrote:
>> This patch includes below fixes for error handling:
>> 1. return proper error if kcalloc for mcspi->dma_channels fails
>> 2. return proper error if omap2_mcspi_master_setup fails
>> 3. properly release allocated resources in error paths and
>>   improve the naming of goto labels.
>
> Is this to be applied immediately, or queued up in linux-next for v3.1?
>
It's not urgent. It's ok to queue up in linux-next for v3.1.

Axel
