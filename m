Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1GJNzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 09:55:31 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:15977 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1GJNz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 09:55:26 -0400
Date: Sun, 10 Jul 2011 09:55:50 -0400
To: "Ric Wheeler" <ricwheeler@gmail.com>, "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
From: "Sorin Faibish" <sfaibish@emc.com>
Cc: "Hans-Peter Jansen" <hpj@urpla.net>,
        "Andrew Morton" <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp,
        "James Morris" <jmorris@redhat.com>,
        "Bruce Fields" <bfields@redhat.com>,
        "Steve Dickson" <SteveD@redhat.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Message-ID: <op.vyeog2k5rwwil4@sfaibish1.corp.emc.com>
User-Agent: Opera Mail/9.63 (Win32)
MIME-Version: 1.0
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org>
 <201107052154.32606.hpj@urpla.net> <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
 <4E196175.2020307@gmail.com>
In-Reply-To: <4E196175.2020307@gmail.com>
Content-Transfer-Encoding: 8bit
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 04:23:17 -0400, Ric Wheeler <ricwheeler@gmail.com>
wrote:

> On 07/08/2011 01:57 PM, Miklos Szeredi wrote:
>> "Hans-Peter Jansen"<hpj@urpla.net>  writes:
>>
>>> All kodos to you, Miklos. While I'm still missing a major feature from
>>> overlayfs that is a NFS as upper layer, it provides a fairly good
>>> start. A commitment from you, that such an extension is considered for
>>> inclusion - given, that it appears one day - is appreciated. Also,
>>> since xattr support is available for NFS,
>> AFAIK development of generic xattr support on NFS stopped some time ago.
>
> Hi Miklos,
>
> There is a proposed (at the IETF) standard called "labelled NFS" that  
> would allow the protocol to handle xattrs.
Will be included in NFSv4.2. And we are already very close to a good I-D.
Not sure that xattr change mentioned here will be included. You can look
at the current I-D at:
http://datatracker.ietf.org/doc/draft-quigley-nfsv4-labeled/

/Sorin

>
> It has not set the world on fire in terms of enthusiasm, but has been  
> making some progress. We have patches from Dave Quigley that did work,  
> but need to resolve the standards issues I suspect before it could make  
> progress upstream...
>
> Ric
>
>>> it would be nice to outline, what is missing for such an
>>> implementation from overlayfs's POV.
>> Allow using namspace polluting xattr replacements, such as aufs is
>> doing.
>>
>> But why?  Why is it better to do the overlaying on the client instead of
>> the server?
>>
>> Thanks,
>> Miklos
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Best Regards
Sorin Faibish
Corporate Distinguished Engineer
Unified Storage Division

         EMC²
where information lives

Phone: 508-435-1000 x 48545
Cellphone: 617-510-0422
Email : sfaibish@emc.com
