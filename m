Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1GFDpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:45:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab1GFDpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:45:09 -0400
Message-ID: <4E13DA40.5020000@redhat.com>
Date: Tue, 05 Jul 2011 23:45:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v5 1/9] introduce kvm_read_guest_cached
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 11:32 AM, Glauber Costa wrote:
> From: Gleb Natapov<gleb@redhat.com>
>
> Introduce kvm_read_guest_cached() function in addition to write one we
> already have.
>
> [ by glauber: export function signature in kvm header ]
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> Signed-off-by: Glauber Costa<glommer@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
