Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1KIPai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:30:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1KIPah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:30:37 -0500
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics
 inside cpu cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Wagin <avagin@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, pjt@google.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Date: Wed, 09 Nov 2011 16:30:23 +0100
In-Reply-To: <CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	 <1320182360-20043-14-git-send-email-glommer@parallels.com>
	 <CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
	 <4EBA6AF7.4020509@parallels.com>
	 <CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320852623.19727.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 17:18 +0300, Andrew Wagin wrote:
> And look at cfs_rq->prev_sum_exec_runtime, probably it is not used too.
> Usage of cfs_rq->sum_exec_runtime looks strange.

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
