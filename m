Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1HPBSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 21:18:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HPBSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 21:18:15 -0400
Date: Tue, 16 Aug 2011 03:18:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Solar Designer <solar@openwall.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
Message-ID: <20110816011807.GA5782@one.firstfloor.org>
References: <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110815185114.GA20115@openwall.com> <4E496CAC.3030103@zytor.com> <20110815201419.GA20296@openwall.com> <CACLa4puLxL+azpYjQsD6eDKU=LPJ1mrF1LUrc5Gy-89a8fvjpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACLa4puLxL+azpYjQsD6eDKU=LPJ1mrF1LUrc5Gy-89a8fvjpQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 06:13:51PM -0400, Eric Paris wrote:
> On Mon, Aug 15, 2011 at 4:14 PM, Solar Designer <solar@openwall.com> wrote:
> 
> > So how do we proceed from here?  Start by getting Will's patch applied?
> 
> How to move forward with Will's patch is supposed to be discussed at
> the invite only kernel summit October 23 - 25, 2011.  As one of the

linux-kernel is really the primary forum. If you want to discuss
something just discuss it here (ideally with patches)

May the best patch win.

-Andi
