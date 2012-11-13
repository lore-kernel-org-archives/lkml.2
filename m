Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KMDml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:42:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2KMDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:42:40 -0500
Message-ID: <50A1C1A1.7060200@vlnb.net>
Date: Mon, 12 Nov 2012 22:42:25 -0500
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <20121025051445.GA9860@thunk.org> <508B3EED.2080003@vlnb.net> <CABK4GYMmigmi7YM9A5Aga21ZWoMKgUe3eX-AhPzLw9CnYhpcGA@mail.gmail.com>
In-Reply-To: <CABK4GYMmigmi7YM9A5Aga21ZWoMKgUe3eX-AhPzLw9CnYhpcGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:pDU+3oPLsasYbL4hQOMK/uCFz6QImKwBlROxaIM2NHr
 n1Gp68NvORHayR3Jj/cLYNF0AnSWqcTPdzh6/lotfQiqDQV4dt
 fa39QL6Zn3HBHQUtK9CASRsccdlilc3KlAkymLuwA/+Rzw0gq8
 01GcrhhF2lC9eb9mXGOeC86Jwg8b1GBXCjhGdxkhNo0brYS2zr
 WsmoJqvecoRD78omiIi4YK92PCgT1BM0DP4vNiWJui4lZ6EwQG
 /0zKffxMxkm6iXBnnVxdCGyIDjgMT1H4qSVb0+pJlhwIs2CaTI
 kZH/TE4TKto7SjXY2XPK4M8ZnbZ+xcKJYMXQ7/omJQ4YXBYXun
 P2QJdDWKyc2ips/g7Ybs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

杨苏立 Yang Su Li, on 11/10/2012 11:25 PM wrote:
>>  SATA's Native Command
>>> Queuing (NCQ) is not equivalent; this allows the drive to reorder
>>> requests (in particular read requests) so they can be serviced more
>>> efficiently, but it does *not* allow the OS to specify a partial,
>>> relative ordering of requests.
>>>
>>
>> And so? If SATA can't do it, does it mean that nobody else can't do it
>> too? I know a plenty of non-SATA devices, which can do the ordering
>> requirements you need.
>>
>
> I would be very much interested in what kind of device support this kind of
> "topological order", and in what settings they are typically used.
>
> Does modern flash/SSD (esp. which are used on smartphones) support this?
>
> If you could point me to some information about this, that would be very
> much appreciated.

I don't think storage in smartphone can support such advanced functionality, 
because it tends to be the cheapest, hence the simplest.

But many modern Enterprise SAS drives can do it, because for those customers 
performance is the key requirement. Unfortunately, I'm not sure I can name exact 
brands and models, because I had my knowledge from NDA'ed docs, so this info can 
be also NDA'ed.

Vlad
