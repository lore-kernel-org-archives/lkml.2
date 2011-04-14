Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab1DNCyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:54:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65198 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1DNCym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gJATxIKqUt40YAMPHaOk0Gcztm+DwzNraE59e7hZ9MvPMYzTqHCdHQyQl1Ly4PJG3I
         xR6mxl78GP6PBRlmTgD8TvhB9+IWctf+c/mr5Cr5vpCjAToTatavQET9brupMvYwDkd0
         DztI1QeuHGxwkub2t9Jfu+j1oBhxpyJOHnAUg=
Subject: Re: [patch v3 2/3] percpu_counter: fix code for 32bit systems for
 UP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>, "cl@linux.com" <cl@linux.com>
In-Reply-To: <1302749044.3981.183.camel@sli10-conroe>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
	 <20110414020747.201728372@sli10-conroe.sh.intel.com>
	 <1302748530.3549.24.camel@edumazet-laptop>
	 <1302749044.3981.183.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 04:54:37 +0200
Message-ID: <1302749677.3549.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 10:44 +0800, Shaohua Li a écrit :
> that's true. I just want the code looks consistent and this doesn't
> really obfuscate the code to me.

Doing so gives a false sense of security to user.

percpu_counter_init() is unsafe by nature.



