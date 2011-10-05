Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab1JEGjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab1JEGjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:39:12 -0400
Date: Wed, 5 Oct 2011 08:39:45 -0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pawel Moll <pawel.moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio: Add platform bus driver for memory mapped virtio
 device
Message-ID: <20111005103944.GB5587@redhat.com>
References: <1317217663-32647-1-git-send-email-pawel.moll@arm.com>
 <878vp1iqpz.fsf@rustcorp.com.au>
 <1317745002.3158.340.camel@hornet.cambridge.arm.com>
 <87aa9ggs4k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa9ggs4k.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 11:40:51AM +1030, Rusty Russell wrote:
> The absolute maximum is a ring of 32k elements, which is about 850k.
> That seems a little excessive, though.

Given that it must be physically contigious and each descriptor
is 64 byte in size + space for used and avail rings, yes it does :)

