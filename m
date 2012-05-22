Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2EVNu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:50:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2EVNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXh+0LECyLJ-MrDBZf2ZwLv5BJk0+DCFgPzqSChrFV=2WA@mail.gmail.com>
References: <j2MgV-2Qe-9@gated-at.bofh.it>
	<4FB8B2E6.5010601@onlinehome.de>
	<CAJd=RBDY3Vd8EYFz=n6smFK2EhypgHpvyC_eG1QyE3Us-Y8-qg@mail.gmail.com>
	<CANQmPXh+0LECyLJ-MrDBZf2ZwLv5BJk0+DCFgPzqSChrFV=2WA@mail.gmail.com>
Date: Tue, 22 May 2012 21:50:24 +0800
Message-ID: <CAJd=RBDbqMHcmKdFVJEEq8LSQP1+Dfo7ancWhTV4uR2fO9k+Jg@mail.gmail.com>
Subject: Re: BFS 420: cleanup in tick handling
From: Hillf Danton <dhillf@gmail.com>
To: Chen <hi3766691@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 9:45 PM, Chen <hi3766691@gmail.com> wrote:
> Actually the lowest deadline task selection algorithm now BFS used is O(n).
> I have already had an idea to enhance the lowest deadline task selection
> algorithm to O(1)

Would you please announce it on LKML?
