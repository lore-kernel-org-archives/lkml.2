Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1LSO2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:28:11 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:39675 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752300Ab1LSO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:28:08 -0500
Message-ID: <4EEF49EE.2080302@tao.ma>
Date: Mon, 19 Dec 2011 22:27:58 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andreas Dilger <adilger@whamcloud.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V3 01/21] ext4: Move extra inode read to a new function.
References: <4EEDF6B1.7050206@tao.ma> <1324218278-2460-1-git-send-email-tm@tao.ma> <BB5BC380-D840-4AD8-80CC-C320AF780FEF@whamcloud.com>
In-Reply-To: <BB5BC380-D840-4AD8-80CC-C320AF780FEF@whamcloud.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.245.225.112 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 04:32 PM, Andreas Dilger wrote:
> On 2011-12-18, at 15:24, Tao Ma <tm@tao.ma> wrote:
> 
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Currently, in ext4_iget we do a simple check to see whether
>> there does exist some information starting from the end
>> of i_extra_size. With inline data added, this procedure
>> is more complicated. So move it to a new function named
>> ext4_iget_extra_inode.
>>
>> +        } else
>> +            ext4_iget_extra_inode(inode, raw_inode, ei);
>>    } else
> 
> (style) if one half of an if-else uses braces then the other half should as well. 
sure, I will change it in the next version. Thanks for the review.

Thanks
Tao
