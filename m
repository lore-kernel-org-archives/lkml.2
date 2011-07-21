Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GUITb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:19:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46813 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1GUIT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:19:27 -0400
Date: Thu, 21 Jul 2011 10:19:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Note on Linux 3.0 and the 3.1 merge window
Message-ID: <20110721081921.GA2986@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxKbAXXv2x0ykezsXbSeZZQ0DwPRzYPY_QZ0NdFKes_NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxKbAXXv2x0ykezsXbSeZZQ0DwPRzYPY_QZ0NdFKes_NQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 06:38:45PM -0700, Linus Torvalds wrote:
>  - Please do spend the time doing some last-minute checking of the
> current git tree. The 3.0 release hasn't really had a lot of
> fundamental changes, and the pathname bug Hugh found wasn't even a
> regression - it's been there a while and was in no way a 3.0 thing. So
> I don't really expect any huge issues, but just for psychological
> reasons it would be nice to not have even a whiff of the traditional
> ".0 problems" .

Just built and booted 3.0.0-rc7-00176-gcf6ace1 here - it feels pretty
solid, not even a squeak in dmesg or some other hint of problems. I'll
keep watching it...

-- 
Regards/Gruss,
    Boris.
