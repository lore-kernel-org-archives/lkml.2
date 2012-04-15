Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2DOVfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:35:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51307 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2DOVfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:35:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9xbM49N7wVkUBBpYNQ+Lwt2WU=axdQ+1gmp5G8N0LR2sxbpA@mail.gmail.com>
References: <20110307021127.GB31188@google.com>
	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	<20110309112550.GA3050@google.com>
	<alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
	<20110311021654.GA26122@google.com>
	<20110311024851.GC26122@google.com>
	<20120305000112.GA27512@burratino>
	<3908561D78D1C84285E8C5FCA982C28F041A65@ORSMSX104.amr.corp.intel.com>
	<20120305234240.GB1360@burratino>
	<CAA9xbM4iviwVG2VrdEiTom6SueLDviHC+An87ypvQGR1665iwg@mail.gmail.com>
	<CAA9xbM49N7wVkUBBpYNQ+Lwt2WU=axdQ+1gmp5G8N0LR2sxbpA@mail.gmail.com>
Date: Sun, 15 Apr 2012 23:35:21 +0200
Message-ID: <CAA9xbM5vEyw6wSghJPLdaY3_gfme1scfdYYDe92Rmdg+NitBww@mail.gmail.com>
Subject: Re: [regression] Re: [PATCH 2/3] futex: Sanitize cmpxchg_futex_value_locked
 API
From: =?ISO-8859-1?Q?=C9meric_Maschino?= <emeric.maschino@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Patrick Baggett <baggett.patrick@gmail.com>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Patch proposed by Tony in
https://bugzilla.kernel.org/show_bug.cgi?id=42757 works for me :-)

Many thanks,

    Emeric



Le 8 mars 2012 22:12, Émeric Maschino <emeric.maschino@gmail.com> a écrit :
> Oops, just to correct myself: the tests described below DON'T return
> gracefully with kernel 3.2. Sorry for the mistake.
>
>     Emeric
>
>
> Le 8 mars 2012 21:59, Émeric Maschino <emeric.maschino@gmail.com> a écrit :
>> ERROR: No such process: FUTEX_CMP_REQUEUE_PI failed
>>
>> For memories, this test passed successfully with 2.6.38-rc8+, with AND
>> without 37a9d912b24f included.
>>
>> Now, adding locked argument, I'm getting:
>>
>> ERROR: Function not implemented: FUTEX_REQUEUE_PI failed
>>
>> Huh? Both these tests nevertheless gracefully return with kernel 3.2,
>> while the second test enters in an unfinite loop with buggy
>> 2.6.38-rc8+.
