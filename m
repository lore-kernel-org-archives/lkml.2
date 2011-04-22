Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1DVUtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:49:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58253 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1DVUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:49:34 -0400
Message-ID: <4DB1E9D4.3080107@oracle.com>
Date: Fri, 22 Apr 2011 13:49:24 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <20110422200945.GA15387@elie>
In-Reply-To: <20110422200945.GA15387@elie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DB1E9D8.003D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 01:10 PM, Jonathan Nieder wrote:
> Hi,
>
> Josef Bacik wrote:
>
>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
>> using fiemap in things like cp cause more problems than it solves, so lets try
>> and give userspace an interface that doesn't suck.  So we have
> That's easy to believe, but could you elaborate?  What problem does
> using fiemap cause?  I assume the answer is somewhere in somewhere in
> the thread
>
>   http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895/focus=24404
>
> but it would be nice to have a summary in the commit log for
> posterity.

http://article.gmane.org/gmane.comp.file-systems.ext4/24465
