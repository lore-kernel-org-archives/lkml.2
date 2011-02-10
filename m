Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1BJRaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:30:03 -0500
Received: from lo.gmane.org ([80.91.229.12]:54739 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BJRaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:30:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ael <law_ence.dev@ntlworld.com>
Subject: Re: [PATCH 7/8] sr: implement sr_check_events()
Date: Thu, 10 Feb 2011 17:30:36 +0000
Message-ID: <ij17a5$825$1@dough.gmane.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-8-git-send-email-tj@kernel.org> <4D44BE3E.5080107@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-oxfd6-0-0-cust236.4-3.cable.virginmedia.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
In-Reply-To: <4D44BE3E.5080107@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure whether these patches are responsible, but I have been seeing 
problems mounting dvd media since 2.6.38-rc3. It improved slightly with
2.6.38-rc4, but I have to use 2.6.38-rc1 (rc2 not tested) to mount some 
of my dvd-rw media.

Message is (from memory & approximately) media already mounted or device 
busy after

mount /dev/dvd /dvd

Apologies for such a vague report not properly investigated, but maybe. 
or maybe not, better than nothing.

ael

