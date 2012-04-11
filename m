Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab2DKQGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:06:24 -0400
Received: from relay.parallels.com ([195.214.232.42]:60507 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765Ab2DKQGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:06:22 -0400
Message-ID: <4F85ABE8.5030203@parallels.com>
Date: Wed, 11 Apr 2012 20:06:00 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/8] NFSd: precursor and cleanup patch set
References: <20120328150152.2646.33607.stgit@localhost6.localdomain6> <20120411160523.GA28928@fieldses.org>
In-Reply-To: <20120411160523.GA28928@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.04.2012 20:05, J. Bruce Fields пишет:
> On Wed, Mar 28, 2012 at 07:08:53PM +0400, Stanislav Kinsbursky wrote:
>> This patch set prepares ground for making NFSd export and expkey caches
>> allocated and registered per network namespace context.
>> Mainly, it just replaces hard-coded pointers with dereferenced everywhere
>> required.
>>
>> The following series consists of:
>
> OK, thanks, applying these all pending some testing.  I'll try to get a
> for-3.5 branch with this pushed out later today or tomorrow.
>

Ok, thanks, Bruce.

-- 
Best regards,
Stanislav Kinsbursky
