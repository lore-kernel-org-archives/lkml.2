Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0EKIf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab0EKIfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:35:25 -0400
Message-ID: <4BE916CA.6030501@redhat.com>
Date: Tue, 11 May 2010 11:35:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH v3 0/8] pvclock fixes - v3
References: <1273094839-18655-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1273094839-18655-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:27 AM, Glauber Costa wrote:
> Hello,
>
> Avi, this version fixes the issues you raised in the last
> review. Hopte it is better now.
>
>    

Sorry about the late review.  Looks reasonable, apart from a couple of 
minor points.

> A cpuid.txt wil follow as soon as we're set on everything, so
> I am not including it yet.
>    

Pity, for a reviewer it is a lot easier to review a spec, then the 
code's conformity to the spec, instead of having to reverse engineer the 
intent from the code.  Please include it next time.

-- 
error compiling committee.c: too many arguments to function

