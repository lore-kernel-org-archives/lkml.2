Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0FICm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:42:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0FICm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:42:27 -0400
Subject: Re: When and how to use ftrace?
From: Steven Rostedt <srostedt@redhat.com>
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
In-Reply-To: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
References: <AANLkTik0UvRGmGeZOMaJVaoHk-lv2V8umAF3EIckh9CT@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 08 Jun 2010 22:42:09 -0400
Message-Id: <1276051329.13426.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 09:38 +0800, Ryan Wang wrote:
> Hi all,
> 
>        I'm new to kernel development, and I'm learning
> ftrace recently. I have one question:
>        When to use ftrace, or in which cases ftrace can be
> more efficient?

I can't really answer these questions without knowing what you want to
do?

ftrace allows you to see what is happening inside the kernel. What would
you like to see?

-- Steve


