Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552Ab0EEPSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:18:13 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:40166 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760530Ab0EEPSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:18:10 -0400
Message-ID: <4BE18B30.10700@cs.columbia.edu>
Date: Wed, 05 May 2010 11:13:52 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Matt Helsley <matthltc@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
References: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <3803.1272984193@redhat.com>
In-Reply-To: <3803.1272984193@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I suppose you are looking for more details than those found in the
current patch-0 (http://lkml.org/lkml/2010/5/1/140).

We omitted them for brevity sake; here is a link to patch-0 of a 
previous post of the patchset: http://lkml.org/lkml/2009/9/23/423

Thanks,

Oren.

David Howells wrote:
> With a huge patch series like this, can you post a cover note at the front
> (usually patch 0) saying what the point of the whole series is?
> 
> David
> 

