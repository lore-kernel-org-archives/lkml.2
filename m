Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1ATIHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:07:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53471 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1ATIHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=S6YTNujhrVyRc7UlmTEEHOtZH4IAPDFoh2hDDpThqGXhJht1TjilesYx1qgWuAC4YS
         KbmgoGK0YJEZaOsO6EjEPxssu+CGzHTUF8n6vzhTaVZ/8DMlMcD5cGY/3L9x+JXy6/Ea
         bc0DfjQr3SADJMdFmnJavmEokVOLDYP6xOUK0=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: monstr@monstr.eu
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>
	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>
	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>
	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>
	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>
	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>
	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu>
	<87r5cc5zqp.fsf@macbook.be.48ers.dk> <4D345DA3.8020105@monstr.eu>
	<87oc7cgbi1.fsf@macbook.be.48ers.dk> <4D37EC89.2080802@monstr.eu>
Date: Thu, 20 Jan 2011 09:06:55 +0100
In-Reply-To: <4D37EC89.2080802@monstr.eu> (Michal Simek's message of "Thu, 20
	Jan 2011 09:04:25 +0100")
Message-ID: <87d3nsdmn4.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:

Hi,

 >> /* flush input and output queues, important for modems! */
 >> tcflush(0, TCIOFLUSH);
 >> 
 >> You could change that to a tcdrain() if that's not what you want.
 >> 

 Michal> Great that's work. Just for the record it is tcdrain(STDOUT_FILENO);

Yes. Notice that the code has changed a bit in busybox git (but same
functionality).

 Michal> Patch against busybox 1.14.3 version is below. Maybe worth to
 Michal> added it mainline busybox.

Yes, please bring it up with the busybox devs.

 Michal> Thanks for your big help.

You're welcome.

-- 
Bye, Peter Korsgaard
