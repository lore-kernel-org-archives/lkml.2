Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0GHOQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0GHOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:16:39 -0400
Message-ID: <4C35DD97.90103@redhat.com>
Date: Thu, 08 Jul 2010 10:15:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
       anton@samba.org
Subject: Re: [PATCH] Add trace event for munmap
References: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 10:05 AM, Eric B Munson wrote:
> This patch adds a trace event for munmap which will record the starting
> address of the unmapped area and the length of the umapped area.  This
> event will be used for modeling memory usage.

Sounds like a useful trace point to me.

> Signed-of-by: Eric B Munson<emunson@mgebm.net>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
