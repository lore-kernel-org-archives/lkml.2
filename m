Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0FAL3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:29:05 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:53167 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0FAL3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F+zpAx+8VrB2qMoVglH61TkEyaTkDLBREtDrHAsicVRqM6CmZMCMHVhpIIQ2gyqBCF
         TaUDggrjl85A9kZXlkfB0h+3ZivK/Qespc+LV03QaAoIReYbqll1vOwozBRBw43FFcU2
         bJEoEE52pg78TAmcXQ311/m+GJXc3bZcs40Co=
MIME-Version: 1.0
In-Reply-To: <4C04ECA3.1080905@netservers.co.uk>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<4BACE827.4070006@gmail.com>
	<20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>
	<4BB31E00.8060204@netservers.co.uk>
	<20100529021624.GA2538@brick.ozlabs.ibm.com>
	<AANLkTil7fk_ikrSPiZnqcJSLGCrzcCrCwbeuUMY5Yu5v@mail.gmail.com>
	<4C04ECA3.1080905@netservers.co.uk>
Date: Tue, 1 Jun 2010 13:28:59 +0200
Message-ID: <AANLkTinpsIs7qMSpQ78fWCTHh03iLBIwRlsU7sqJau08@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Ben McKeegan <ben@netservers.co.uk>
Cc: Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 13:18, Ben McKeegan <ben@netservers.co.uk> wrote:

> This isn't really a bug fix.  Its a behavioural change to work around poor
> quality/mismatched underlying PPP channels.

Maybe not a bug in the Linux kernel itself, but certainly in the real world
that exists around Linux. Similar to how a change to a device driver that
is needed to work around broken hardware is a bug fix, imo.


RIchard
