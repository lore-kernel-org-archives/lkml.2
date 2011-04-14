Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab1DNKra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:47:30 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:55694 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1DNKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:47:28 -0400
Message-ID: <4DA6D0BE.9040305@ece.ntua.gr>
Date: Thu, 14 Apr 2011 13:47:26 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110407 Lightning/1.0b3pre Lanikai/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Two questions about paravirt boot sequence(head_32.S)
References: <4DA6CD8F.6080206@ece.ntua.gr>
In-Reply-To: <4DA6CD8F.6080206@ece.ntua.gr>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Thu, 14 Apr 2011 13:47:27 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 01:33 PM, Stratos Psomadakis wrote:
> 1)I cannot understand why the WEAK entries are required after the
> bad_subarch label :/ Any hints
ok, the first question is just stupid, sorry for that one... :x

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

