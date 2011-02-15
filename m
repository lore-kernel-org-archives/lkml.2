Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1BOPWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1BOPWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:22:47 -0500
Message-ID: <4D5A9ACB.6020607@redhat.com>
Date: Tue, 15 Feb 2011 10:24:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH v3 3/6] KVM-GST: KVM Steal time accounting
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>	 <1297448364-14051-4-git-send-email-glommer@redhat.com>	 <4D5A8F28.4090306@redhat.com> <1297781155.2413.16.camel@twins> <4D5A9909.90305@redhat.com>
In-Reply-To: <4D5A9909.90305@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 10:17 AM, Avi Kivity wrote:

> Ah, so we're all set. Do you know if any user tools process this
> information?

Top and vmstat have been displaying steal time for
maybe 4 or 5 years now.
