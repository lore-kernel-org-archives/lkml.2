Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2AKKgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:36:40 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45620 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab2AKKgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:36:39 -0500
Message-ID: <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 11:36:36 +0100
In-Reply-To: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 11 janvier 2012 à 11:18 +0100, Borzenkov, Andrey a écrit :

> What can be the reason for system consuming half of physical memory for page tables?
> 

Why dont you use hugepages to map oracle SGA ?

If not, its normal to eat so much memory for page tables

grep VmPTE /proc/*/status



