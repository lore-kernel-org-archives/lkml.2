Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1IGRwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:52:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1IGRww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:52:52 -0400
Message-ID: <4E67AF6A.9090400@redhat.com>
Date: Wed, 07 Sep 2011 19:52:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Paul Clements <paul.clements@us.sios.com>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nbd-general@lists.sourceforge.net
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com> <1315406503-7883-3-git-send-email-pbonzini@redhat.com> <CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
In-Reply-To: <CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 06:30 PM, Paul Clements wrote:
> Could you name this as NBD_SET_FLAGS, as that's more consistent with
> what it's really doing?

I named it differently intentionally, actually, because it should not 
use the flags field from the network protocol as is.  Also, "features" 
sounds more like something that is optional, while unrecognized "flags" 
should probably cause a failure.

What about renaming the struct field and leaving this as 
NBD_SET_FEATURES or NBD_ENABLE_FEATURES?

Paolo
