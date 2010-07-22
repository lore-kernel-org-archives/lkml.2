Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0GVVAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:00:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:46654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0GVVAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:00:47 -0400
Message-ID: <4C48B16B.2070605@kernel.org>
Date: Thu, 22 Jul 2010 23:00:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCHSET wq#for-next] workqueue: replace slow-work with workqueue
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 21:00:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 10:34 PM, Tejun Heo wrote:
>  0001-fscache-convert-object-to-use-workqueue-instead-of-s.patch
>  0002-fscache-convert-operation-to-use-workqueue-instead-o.patch
>  0003-fscache-drop-references-to-slow-work.patch
>  0004-cifs-use-workqueue-instead-of-slow-work.patch

0001-0004 now pushed out to wq#for-next w/ acks added.

Thank you.

-- 
tejun
