Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1HTMIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 08:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1HTMIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 08:08:44 -0400
Message-ID: <4E4FA3B9.6000203@redhat.com>
Date: Sat, 20 Aug 2011 08:08:25 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, chris.mason@oracle.com
Subject: Re: [PATCH] BTRFS: Free inode mutex on lseek error
References: <1313798858-10938-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1313798858-10938-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 08:07 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Introduced with b26751575a9aa55fd6dbf3febde3ff06dfadc44f
> 

This has already been fixed by

9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

Thanks,

Josef
