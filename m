Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1BHXcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:32:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab1BHXb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:31:59 -0500
Date: Tue, 8 Feb 2011 15:31:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@linux.it>, lkml <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: PPS build warning
Message-Id: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
In-Reply-To: <1296610293.3336.142.camel@work-vm>
References: <1296610293.3336.142.camel@work-vm>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Alexander)

On Tue, 01 Feb 2011 17:31:33 -0800
john stultz <johnstul@us.ibm.com> wrote:

> Hey Rodolfo,
> 	Just ran into the following:
> 
> drivers/pps/kapi.c: In function 'pps_event':
> drivers/pps/kapi.c:196: warning: 'ts_real.flags' may be used uninitialized in this function
> 
> Looks like you don't set the flags value in timespec_to_pps_ktime when
> you initialize the rest of the structure.
> 

