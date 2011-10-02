Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1JBUQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:16:42 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:35351 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1JBUQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:16:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: CIFS kernel module bug
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
Date: Sun, 2 Oct 2011 21:16:33 +0100
Cc: =?iso-8859-1?Q?Lars_M=FCller?= <lmuelle@suse.de>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeremy Allison <jra@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <65C75335-2A74-4B00-989A-212BAC06A646@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net> <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk> <20110930234711.GD14147@samba2> <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk> <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk> <20111001150730.GJ5170@giles.fritz.box> <6A5AB13C-F313-4BF2-A402-F41AB53493F0@cam.ac.uk> <CAFneQcc8D7ho-Yfr2X0DxaLLX11iMU=wSgCw9daKoViZCMk6dA@mail.gmail.com>
To: Jim McDonough <jmcd@samba.org>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 1 Oct 2011, at 21:22, Jim McDonough wrote:
> On Sat, Oct 1, 2011 at 3:53 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>> On 1 Oct 2011, at 16:07, Lars Müller wrote:
>>> On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>>>> 
>>>> On 1 Oct 2011, at 01:34, J.P. King wrote:
>>>>> Anton will be asleep, so I'll attempt to answer this one.
>>>>> 
>>>>>> What server code is the OES CIFS server running ? I thought Novell CIFS
>>>>>> services were all Samba based.
>>>>> 
>>>>> We have been told by the people upstairs who run the server that it isn't.
>>>> 
>>>> It is not Samba based.  Like Apple, Novell have written their own since Samba decided to go GPLv3…
>>> 
>>> (Potential) FUD alert. ;)
>> 
>> It wasn't deliberate!  It was just a guess as until recently I also though that OES just used Samba so when I two weeks ago found out that it didn't I just assumed that Novell must have written it recently and then drew the parallel to Apple and just assumed that it was an analogous case…
> 
> I believe both are available on OES, samba and the CIFS server that
> has its origins in Netware.

That is correct but apparently Salford Software (who handle our Netware & OES site license here in the UK including providing support) have told the guys running the file server that the samba server on OES is not scalable, has loads of bugs, and they must stay away from it at all costs and that they would not provide any support if our filestore runs that instead of the Novell CIFSd.

You can understand why the filestore is thus running the Novell CIFSd rather than Samba…

PS. Whether this is FUD or not I cannot comment on.  I am just passing on what I was told!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

