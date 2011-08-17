Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1HQBXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 21:23:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57800 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab1HQBXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 21:23:17 -0400
Message-ID: <4E4B181E.8000508@cn.fujitsu.com>
Date: Wed, 17 Aug 2011 09:23:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dan Merillat <dan.merillat@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: processes stuck in llseek
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com>	<1313499055-sup-2296@shiny> <CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com>
In-Reply-To: <CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 09:22:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 09:22:05,
	Serialize complete at 2011-08-17 09:22:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Merillat wrote:
> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -0400:
> 
>> Dan Carpenter sent a patch for this, I'll get it queued up for rc3.
> 
> Can you send it?  I'd like to test it to see if it fixes my system.

Here it is.

http://marc.info/?l=linux-btrfs&m=131176036219732&w=2

--
Li Zefan
