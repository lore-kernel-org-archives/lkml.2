Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0ELGeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0ELGeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:34:04 -0400
Message-ID: <4BEA4BD4.6070207@redhat.com>
Date: Wed, 12 May 2010 09:33:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] pvclock misc fixes - v4.
References: <1273594667-17175-1-git-send-email-glommer@redhat.com> <4BEA21A1.8040702@redhat.com> <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de>
In-Reply-To: <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 08:47 AM, Alexander Graf wrote:
> How about stable queuing of this one?
>

Only after this gets some serious field testing.  I'm not happy to trade 
a known issue for an unknown regression.  While I don't expect any 
problems with the patchset, testing has often proven me wrong.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

