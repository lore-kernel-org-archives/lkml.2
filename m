Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0JDHpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:45:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47797 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0JDHpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c73/3HrdvlUsEF2BcjpFVcInhpi6CibkMXqegaS0Aw0GaIumSLDDrNPSJsJfzCMTed
         WG1hIgOTV3FOBynHJJ8KvcZlbFJo1pNg2+BpMSZ2fXvBfTvxkXglBzmCyqmcy+Rc4xmJ
         wMSi4kYD3/dAyGyDtb/8weouk0gJuy56QIzCg=
MIME-Version: 1.0
In-Reply-To: <N9RAiGGLCfN.A.3rD.tVPqMB@chimera>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
	<N9RAiGGLCfN.A.3rD.tVPqMB@chimera>
Date: Mon, 4 Oct 2010 08:45:33 +0100
Message-ID: <AANLkTim_fBnuVX94zKH_u6mOx4pPZK4BfSn1qexj6_wd@mail.gmail.com>
Subject: Re: [Bug #16462] unable to connect to hidden SSID AP on legal channel 13
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 3 October 2010 22:53, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16462
> Subject         : unable to connect to hidden SSID AP on legal channel 13
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Date            : 2010-07-25 17:06 (71 days old)
> Handled-By      : Johannes Berg <johannes.berg@intel.com>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=31862

This patch addresses the issue, though it hasn't been pulled to mainline yet.

Many thanks,
  Daniel
-- 
Daniel J Blueman
