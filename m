Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2DEHUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:20:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32842 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2DEHUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:20:06 -0400
Date: Thu, 5 Apr 2012 00:20:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vichy <vichy.kuo@gmail.com>
cc: Kautuk Consul <consul.kautuk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: some questions about __get_vm_area_node
In-Reply-To: <CAOVJa8GEVr69+FStuiyu3vyejD+4PZtyKm=vO3n9=LkqgS==1Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204050017290.11895@chino.kir.corp.google.com>
References: <CAOVJa8EVHhfFfHHNAyAeT0ZYj3vZFW3Uu4K2PzBEGGOz92fhiw@mail.gmail.com> <alpine.DEB.2.00.1204042308470.7534@chino.kir.corp.google.com> <CAOVJa8GEVr69+FStuiyu3vyejD+4PZtyKm=vO3n9=LkqgS==1Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, vichy wrote:

> Yes, I saw your check in message on Mon Dec 19 17:12:04 2011 -0800.
> BTW, why we declare it as static previously?

Most likely copy-and-paste error by the original author.

> for saving stack usage?

For that you would need some kind of synchronization to protect it from 
concurrent access which doesn't exist in this context, so it was simply a 
mistake that got past review.
