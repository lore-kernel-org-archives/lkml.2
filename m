Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2DSVro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:47:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36008 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2DSVrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <4F907512.9060300@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
 <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com>
 <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com>
 <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com> <4F9072CA.6030903@gmail.com>
 <4F9073A6.4030709@zytor.com> <4F907512.9060300@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 14:47:20 -0700
X-Google-Sender-Auth: gN0R5ycVwQtBvI3rYxERStAeR3Q
Message-ID: <CA+55aFy+J5TeaOZTmtapS1V5Z0y2Byv_VTiHTkLp9EMmx83SXg@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>, ralf@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 1:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Linus, it's not really an x86 patchset, but would you object if I queue
> up David's updated patchset in -tip?  I'll try to get an Ack from Ralf
> for the MIPS portion.

No objections.

             Linus
