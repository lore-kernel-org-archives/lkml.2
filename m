Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1EZLqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:46:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab1EZLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mPMoqY2GzieW5+fBx6QiYM5eGH/HBrOM48izAod/Ay/sKtYojT4egsedFO1IIB7zLG
         Pjq1QmKZh1lLthQzhde3AhQMocSfmBjrqeEPn9wX67uVYWcGPdgYApnKysnaANawOM2y
         bqLBYEvRbPRVyaAv3Mr3Sjzco+c4mmwzKV+OQ=
Date: Thu, 26 May 2011 13:46:47 +0200
From: Tejun Heo <tj@kernel.org>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        greg@kroah.com
Subject: Re: [PATCH 5/6] unicore32: change PERCPU to PERCPU_SECTION
Message-ID: <20110526114647.GH9715@htj.dyndns.org>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
 <82f1e7bdd9b81c5d1a807ab82d7037fa63492a7a.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82f1e7bdd9b81c5d1a807ab82d7037fa63492a7a.1306408804.git.gxt@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:36:57AM +0000, GuanXuetao wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> see commit from Tejun Heo <0415b00d175e0d8945e6785aad21b5f157976ce0>
>   percpu: Always align percpu output section to PAGE_SIZE
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Yeap, sorry about missing unicore32.

 Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
