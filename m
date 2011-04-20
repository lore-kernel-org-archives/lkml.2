Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1DTJMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1DTJMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:12:45 -0400
Message-ID: <4DAEA388.5090104@redhat.com>
Date: Wed, 20 Apr 2011 12:12:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: emulator: Use linearize() when fetching instructions.
References: <1303142753-24562-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1303142753-24562-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:05 PM, Nelson Elhage wrote:
> Since segments need to be handled slightly differently when fetching
> instructions, we add a __linearize helper that accepts a new 'fetch' boolean.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

