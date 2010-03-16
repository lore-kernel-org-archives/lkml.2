Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937353Ab0CPBfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:35:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62756 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0CPBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:35:43 -0400
Message-ID: <4B9EE0A9.5010901@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 09:36:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH] block: make CONFIG_BLK_CGROUP visible
References: <4B9DA6F5.3070606@cn.fujitsu.com> <20100315132149.GA21127@redhat.com>
In-Reply-To: <20100315132149.GA21127@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	---help---
>>  	Generic block IO controller cgroup interface. This is the common
>> @@ -91,7 +92,7 @@ config BLK_CGROUP
>>  	to such task groups.
>>  
>>  config DEBUG_BLK_CGROUP
>> -	bool
>> +	bool "Block cgroup debugging help"
> 
> 
> Why are you making DEBUG_BLK_CGROUP this as a user visible/configurable
> option? This is already controlled by DEBUG_CFQ_IOSCHED. If you don't want
> the DEBUG overhead, just set DEBUG_CFQ_IOSCHED=n and DEBUG_BLK_CGROUP will
> not be selected? Making it user visible does not seem to be buying us
> anything?
> 

Sounds reasonable. A minor question, since DEBUG_BLK_CGROUP is not
visible, the help message for this config is not visible too, so we
still keep it?
