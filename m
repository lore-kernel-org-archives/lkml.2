Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2JZJIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:08:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38772 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2JZJH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:07:56 -0400
Date: Fri, 26 Oct 2012 02:07:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
Subject: Re: where is trace_kmalloc_node?
In-Reply-To: <20121026084648.GA32761@gentoo.L3L6.loongson.cn>
Message-ID: <alpine.DEB.2.00.1210260207210.9101@chino.kir.corp.google.com>
References: <20121026084648.GA32761@gentoo.L3L6.loongson.cn>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, yili0568@gmail.com wrote:

> hello:
> 	everyone, I can't find the definition of trace_kmalloc_node,
> 	where is it?

Look for DEFINE_EVENT(..., kmalloc_node, ...) in 
include/trace/events/kmem.h.
