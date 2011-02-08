Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1BHCxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:53:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51177 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab1BHCxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=IsXXN34Nwm1zG3/JYrYp48/y2J7f1NQN4Cf3SnZtxtVqEQ9+Jbe+303uoS5aV6btrn
         omG92bku616PDB05lpdQqa9pkLNfeVC5DV9r+1SIhTeH/Nr0ChS+DIOUzqQ36fMUMFSF
         P3dUqB5DUK8Lqp/L56qsQ1BawGAvIcetYMiwQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLOSfdO0HVABANiBnKgN540fc0pzqhjDAKAa2B@mail.gmail.com>
References: <AANLkTinLOSfdO0HVABANiBnKgN540fc0pzqhjDAKAa2B@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Tue, 8 Feb 2011 09:52:14 +0700
Message-ID: <AANLkTin-RGqvUDT-GOBQkP2Rn6+2w7AWarSKHseLSORc@mail.gmail.com>
Subject: Re: Regarding Buddy Allocator
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 06:29, Sri Ram Vemulpali <sri.ram.gmu06@gmail.com> wrote:
> Can anyone point me to implementation of buddy allocator, with
> efficient data structures used. Thanks in advance.

I think, indirectly, you can read about buddy allocator in here:
http://lxr.linux.no/#linux+v2.6.37/Documentation/vm/


-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
