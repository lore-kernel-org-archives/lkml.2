Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625Ab1ETKkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:40:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935461Ab1ETKkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:40:20 -0400
Date: Fri, 20 May 2011 12:40:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-ID: <20110520104014.GD11729@random.random>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com>
 <m2fwokj0oz.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fwokj0oz.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 04:07:40PM -0700, Andi Kleen wrote:
> FWIW i had problems in swapping over dmcrypt for a long time -- not
> quite as severe as you. Never really tracked it down.

I use swap over dmcrypt (cryptsetup on raw device) without apparent
problems, I'd like to consider that a safe setup.
