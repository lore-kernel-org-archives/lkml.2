Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0HaGHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:07:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53003 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0HaGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AEBqX6gjEk5lBzKzYrorF3eCAzv/dkvYt94IZ8pwYyOgsznVwlP1k3jy86NchVlNi3
         zTArMNk99UOAZwodqAf1drbyAnzXDHnTZFP/h10FabLf4cvu/jCq4TNUl38mGZafdqVN
         n0Q72DjAdTl4VGgYV2An8ABc0m+Tow4HYWfRE=
Date: Tue, 31 Aug 2010 08:38:06 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/3] x86: misc K8_NB updates
Message-ID: <20100831063806.GA4655@loge.amd.com>
References: <20100827075945.GA5348@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827075945.GA5348@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches are against tip/master as of
v2.6.36-rc3-1233-gf3d0a67

Patch 1 sets the correct dependency to K8_NB for L3 cache index disable code
Patch 2 allows separate handling of gart and AMD northbridges
Patch 3 renames k8.[ch] and CONFIG_K8_NB to the more appropriate amd_nb.[ch] and CONFIG_AMD_NB

Please apply.


Thanks,
Andreas
