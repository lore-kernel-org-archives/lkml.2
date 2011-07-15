Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1GOQ4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:56:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52200 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1GOQ4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:56:46 -0400
Subject: Re: [PATCH] perf tools, x86: fix 32-bit compile on 64-bit system
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        paulus@samba.org
In-Reply-To: <4E205C58.30607@gmail.com>
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com>
	 <4E205C58.30607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 17:38:09 +0200
Message-ID: <1310744289.2586.359.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 09:27 -0600, David Ahern wrote:
> 
> Fairly trivial change to the Makefile. Any objections? I believe Arnaldo
> is out for a few more days and realistically another week to get through
> a month's backlog. 

I took both patches, lets hope Ingo resurfaces soon, otherwise I'll have
to push stuff to Linus directly.
