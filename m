Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3ACKrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:47:41 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:52285 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130103001821.258795ee@annuminas.surriel.com>
References: <20130103001536.7fd1e952@annuminas.surriel.com>
	<20130103001821.258795ee@annuminas.surriel.com>
Date: Thu, 3 Jan 2013 02:47:37 -0800
Message-ID: <CANN689Fm8TfGXJc0nzptq+h7V70aCjpLCOvDJtvkAcCMje-Rng@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] x86,smp: move waiting on contended ticket lock
 out of line
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 9:18 PM, Rik van Riel <riel@redhat.com> wrote:
> Moving the wait loop for congested loops to its own function allows
> us to add things to that wait loop, without growing the size of the
> kernel text appreciably.

Looks good :)
Still-reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
