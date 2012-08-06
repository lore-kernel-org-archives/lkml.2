Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2HFKky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab2HFKkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:40:47 -0400
Message-ID: <501F9F27.708@redhat.com>
Date: Mon, 06 Aug 2012 13:40:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
References: <20120724203628.21081.56884.stgit@bling.home> <20120724204320.21081.32333.stgit@bling.home> <501F99A8.9050006@redhat.com> <501F9E99.9010109@redhat.com>
In-Reply-To: <501F9E99.9010109@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 01:38 PM, Avi Kivity wrote:

> Regarding the implementation, instead of a linked list, would an array
> of counters parallel to the bitmap make it simpler?

Or even, replace the bitmap with an array of counters.

-- 
error compiling committee.c: too many arguments to function
