Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2DNVCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:02:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41785 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2DNVCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:02:24 -0400
Message-ID: <1334437333.2528.112.camel@twins>
Subject: Re: [RFC 0/3] Extend type checking macros
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Apr 2012 23:02:13 +0200
In-Reply-To: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 18:14 -0400, Sasha Levin wrote:
> the forgotten include/linux/typecheck.h 

AH! that's where it was hidden, I knew we had more of that stuff.
