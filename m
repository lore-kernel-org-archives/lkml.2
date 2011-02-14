Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1BNCRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:17:37 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44563 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751256Ab1BNCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:17:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lDtWuwbantri2SBaPgEgZZtRSCgZGbUh5zSB3ch7j9Oe09irNYp1w/4im0fPumC4zKqcv9dxsNJPV72FNFR04glFzdDGD4+Ylwrs/iHHXtrOuePH0s3gP0RALFQ1Fo1E;
Message-ID: <4D5890B6.2090105@tao.ma>
Date: Mon, 14 Feb 2011 10:17:26 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: XFS status update for January 2011
References: <20110213184219.GA22792@infradead.org>
In-Reply-To: <20110213184219.GA22792@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
> On the 4th of January we saw the release of Linux 2.6.37, which contains a
> large XFS update:
>
>      67 files changed, 1424 insertions(+), 1524 deletions(-)
>
> User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
> to convert already allocated space into unwritten extents that return
> zeros on a read,
>    
would you mind describing some scenario that this ioctl can be used. I am
just wondering whether ocfs2 can implement it as well.

Regards,
Tao
