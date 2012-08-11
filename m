Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2HKIgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 04:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2HKIge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 04:36:34 -0400
Date: Sat, 11 Aug 2012 17:36:31 +0900 (JST)
Message-Id: <20120811.173631.454801705875075594.yamato@redhat.com>
To: jan.ceuleers@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] Declaring udp protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <50255DF9.4040503@gmail.com>
References: <20120810.230559.1897275934845172399.yamato@redhat.com>
	<50255393.7070400@gmail.com>
	<50255DF9.4040503@gmail.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 08/10/2012 08:31 PM, Jan Ceuleers wrote:
>> Two points:
>> 
>> - I haven't seen patch 01/15;
> 
> Correction: I have.
> 
>> - these patches should go to netdev rather than lkml
> 
> But this is still the case; MAINTAINERS would have told you that.

Thanks. After reflecting the suggestion from Alan Cox to the patches,
I will v2 patches to netdev.

Masatake YAMATO
