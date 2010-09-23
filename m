Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0IWJYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:24:20 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:54581 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab0IWJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:24:19 -0400
Message-ID: <4C9B1CC0.7030603@alessandroguido.name>
Date: Thu, 23 Sep 2010 11:24:16 +0200
From: Alessandro Guido <ag@alessandroguido.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100908 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: idr_remove called for id=0 which is not allocated
References: <4C9A70B2.3090101@alessandroguido.name> <20100922225612.826b0553.akpm@linux-foundation.org>
In-Reply-To: <20100922225612.826b0553.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really not sure when it was introduced, since I've switched to 
constantly use nouveau only recently, but I don't recall seeing anything 
of this when I tried in 2.6.34.
