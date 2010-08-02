Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0HBRhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:37:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35317 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0HBRhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mVWmYTHe/PWaKbzxjeIU79oos1a4rzLnzv0Ly79kyKMfEqjqaLhiP4sj+5QLk70JRH
         TcJP+r0+JMEuff4Zsj3ntWXJ0sGDChyNnwgIFZOzwV8TqWos740IIDFckj71ANmvmBbt
         0Gl3Yf2czc14osaivhCvr+TRTnF2RJp4bbL1Q=
MIME-Version: 1.0
In-Reply-To: <50761c10ce6cccfbb9f1394641c761f57f4b80c8.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<50761c10ce6cccfbb9f1394641c761f57f4b80c8.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:36:52 -0400
Message-ID: <AANLkTingn9bhuQNu8Y3RUJiA_1KnAfMCgmF+onzj+V=6@mail.gmail.com>
Subject: Re: [PATCH 2/6] arch/blackfin: Remove dead CONFIG_BF535
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:01, Christian Dietrich wrote:
> CONFIG_BF535 doesn't exist in Kconfig, therefore removing all
> references to it from the source. In the past[0] there was also removed
> code for this kind of CPU, reasoning, that it's not supported at all.

while true, i like to keep this vector in the code as a reminder that
we dont have to handle it on newer parts.  so ill pass on this patch.
-mike
