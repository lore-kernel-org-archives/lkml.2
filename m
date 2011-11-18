Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab1KRO5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:57:30 -0500
Received: from smtp3.ugent.be ([157.193.49.127]:57463 "EHLO smtp3.UGent.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab1KRO52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:57:28 -0500
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 09:57:28 EST
Message-ID: <4EC67021.6060905@debian.org>
Date: Fri, 18 Nov 2011 15:48:01 +0100
From: Luk Claes <luk@debian.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: John Hughes <john@Calva.COM>
CC: Steve Dickson <SteveD@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add "-e" option to rpc.gssd to allow error on ticket
 expiry
References: <4EC6426A.3020306@Calva.COM> <4EC66148.4020003@RedHat.com> <4EC664D3.9030402@Calva.COM>
In-Reply-To: <4EC664D3.9030402@Calva.COM>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Miltered: at mcheck5 with ID 4EC66FC7.003 by Joe's j-chkmail (http://helpdesk.ugent.be/email/)!
X-j-chkmail-Enveloppe: 4EC66FC7.003 from dD57720C6.access.telenet.be/dD57720C6.access.telenet.be/213.119.32.198/[172.16.0.2]/<luk@debian.org>
X-j-chkmail-Score: MSGID : 4EC66FC7.003 on smtp3.UGent.be : j-chkmail score : X : R=. U=. O=## B=0.000 -> S=0.166
X-j-chkmail-Status: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 02:59 PM, John Hughes wrote:
> On 18/11/11 14:44, Steve Dickson wrote:
>>
>> On 11/18/2011 06:32 AM, John Hughes wrote:

>> . Plus there is no man page update...
> 
> Okeydoke, let's see, where's the man page...
> 
> $ find  /usr/share/man* -name 'rcp.gssd*'
> 
> find: cannot get current directory: Permission denied

rcp != rpc

Cheers

Luk
