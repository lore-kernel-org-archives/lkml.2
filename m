Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1DEIWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1DEIWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:22:45 -0400
Message-ID: <4D9AD14D.3020705@redhat.com>
Date: Tue, 05 Apr 2011 11:22:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2]arch:x86:kvm:i8254.h Remove base_addresss in kvm_pit
 since it is unused.
References: <1301504087-3266-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1301504087-3266-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 06:54 PM, Justin P. Mattock wrote:
> The patch below removes unsigned long base_addresss; in i8254.h
> since it is unused.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

