Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1CGLfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:35:24 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48641 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1CGLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=fJd/tlnQMIDpQDNtt32RvBzx7cL4HK3MxkS1JOO9qdLYdqp5fkPRKUGcF5DK8/KLvj
         Kcy2IZBIuXMgr1mvm0ZaVlqJXMitwRApTiXiKaFG/Rd/UxK6zwMMsZZ6/FflX8tz6wGX
         /ayg6KHqnJZAlGRvkOAAEK++bapmdTkgdkOak=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D74C101.1030204@kernel.dk>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
	<20110307063618.GA10365@mtj.dyndns.org>
	<4D749A81.50809@kernel.dk>
	<AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
	<20110307104747.GH20499@htj.dyndns.org>
	<AANLkTinBx5Z9Gp7ZTcbbTMCZZ4Z68-vMBP9yOX-k15EA@mail.gmail.com>
	<4D74BE7C.4050701@kernel.dk>
	<AANLkTi=9AUSv0rJtudgnEBERaCLpyHhVmcUY9mZUa8H-@mail.gmail.com>
	<4D74C101.1030204@kernel.dk>
Date: Mon, 7 Mar 2011 12:35:19 +0100
Message-ID: <AANLkTim=ftTzEX9arXjpPhs8XPbUCzZ2BJ3pOdxL+bNF@mail.gmail.com>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00163649a965f6800c049de2e351
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163649a965f6800c049de2e351
Content-Type: text/plain; charset=UTF-8

On 3/7/11, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-03-07 12:25, Sedat Dilek wrote:
>> On 3/7/11, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2011-03-07 12:14, Sedat Dilek wrote:
>>>> On 3/7/11, Tejun Heo <tj@kernel.org> wrote:
>>>>> On Mon, Mar 07, 2011 at 11:41:23AM +0100, Sedat Dilek wrote:
>>>>>> $ git log -1 | cat
>>>>>> commit c45165cd2c77843f24ca18af54044303dc2a81ab
>>>>>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>>>>>> Date:   Mon Mar 7 17:38:41 2011 +1100
>>>>>>
>>>>>>     Add linux-next specific files for 20110307
>>>>>>
>>>>>>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>>>>>
>>>>>> $ git pull
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>>>>>> for-next
>>>>>> remote: Counting objects: 158, done.
>>>>>> remote: Compressing objects: 100% (89/89), done.
>>>>>> remote: Total 106 (delta 87), reused 21 (delta 17)
>>>>>> Receiving objects: 100% (106/106), 23.33 KiB, done.
>>>>>> Resolving deltas: 100% (87/87), completed with 34 local objects.
>>>>>> From
>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block
>>>>>>  * branch            for-next   -> FETCH_HEAD
>>>>>> warning: too many files (created: 1120 deleted: 637), skipping inexact
>>>>>> rename detection
>>>>>> warning: too many files (created: 974 deleted: 462), skipping inexact
>>>>>> rename detection
>>>>>> Auto-merging block/blk-core.c
>>>>>> Auto-merging block/blk-flush.c
>>>>>> CONFLICT (content): Merge conflict in block/blk-flush.c
>>>>>> Auto-merging block/cfq-iosched.c
>>>>>> CONFLICT (content): Merge conflict in block/cfq-iosched.c
>>>>>> Automatic merge failed; fix conflicts and then commit the result.
>>>>>
>>>>> Ummm... don't those conflicts come from Stephen's commits?  You would
>>>>> need to revert the merge and fixup commits and then pull in the block
>>>>> branch.
>>>>>
>>>>> Thanks.
>>>>>
>>>>> --
>>>>> tejun
>>>>>
>>>>
>>>> I have reverted the merge-fix from Stephen "[PATCH] block: update for
>>>> __blk_run_queue() API update" which changed block/blk-flush.c, this
>>>> remains:
>>>> ...
>>>> CONFLICT (content): Merge conflict in block/cfq-iosched.c
>>>>
>>>> As it is 12p.m. and sun shining, my decision and direction is clear:
>>>> Lunch + City.
>>>
>>> Just checked here, I can pull my for-next cleanly into Linus' master.
>>> What is the block tree for-next branch sha?
>>>
>>> --
>>> Jens Axboe
>>>
>>>
>>
>> No, I tried to merge your for-next into linux-next (which will happen
>> with tomorrows linux-next).
>>
>> [ linux-2.6-block.git#for-next ]
>> commit b873c5d692d4d5453cceed18bb06c62bb1a73ac0
>> "Merge branch 'block-for-2.6.39-core' of
>> ssh:///linux/kernel/git/tj/misc into for-2.6.39/core"
>
> linux-next should not have any CFQ changes that don't come from for-next
> from the linux block tree. Are you pulling it into a linux-next that
> already have some of the block changes?
>
> --
> Jens Axboe
>
>

I have reverted the manual merge-fix from Stephen as pointed out by Tejun.

As tig (utility) is broken with ncurses-5.8 in Debian/sid I currently
can't look through the commits.
So, I can't say if there were further modifications by merging block
stuff into linux-next.
I have added the last 5 commits to block/cfq-iosched.c as TXT.

- Sedat -

--00163649a965f6800c049de2e351
Content-Type: text/plain; charset=US-ASCII; 
	name="last-5-commits-to-block_cfq-iosched-c.txt"
Content-Disposition: attachment; 
	filename="last-5-commits-to-block_cfq-iosched-c.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file1

Y29tbWl0IGZlY2VhYWRkNzVjMDM1YWQyOTk5YjkxMjY2YzRmM2NkM2M5MjhkN2QKTWVyZ2U6IDBj
NTRhZDAgNzYzNDE0YgpBdXRob3I6IFN0ZXBoZW4gUm90aHdlbGwgPHNmckBjYW5iLmF1dWcub3Jn
LmF1PgpEYXRlOiAgIE1vbiBNYXIgNyAxMzoxOTo0NyAyMDExICsxMTAwCgogICAgTWVyZ2UgcmVt
b3RlLXRyYWNraW5nIGJyYW5jaCAnYmxvY2svZm9yLW5leHQnCiAgICAKICAgIENvbmZsaWN0czoK
ICAgIAlibG9jay9ibGstZmx1c2guYwoKY29tbWl0IDE2NTRlNzQxMWExYWQ0OTk5ZmU3ODkwZWY1
MWQyYTJiYmIxZmNmNzYKQXV0aG9yOiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CkRhdGU6ICAg
V2VkIE1hciAyIDA4OjQ4OjA1IDIwMTEgLTA1MDAKCiAgICBibG9jazogYWRkIEBmb3JjZV9rYmxv
Y2tkIHRvIF9fYmxrX3J1bl9xdWV1ZSgpCiAgICAKICAgIF9fYmxrX3J1bl9xdWV1ZSgpIGF1dG9t
YXRpY2FsbHkgZWl0aGVyIGNhbGxzIHEtPnJlcXVlc3RfZm4oKSBkaXJlY3RseQogICAgb3Igc2No
ZWR1bGVzIGtibG9ja2QgZGVwZW5kaW5nIG9uIHdoZXRoZXIgdGhlIGZ1bmN0aW9uIGlzIHJlY3Vy
c2VkLgogICAgYmxrLWZsdXNoIGltcGxlbWVudGF0aW9uIG5lZWRzIHRvIGJlIGFibGUgdG8gZXhw
bGljaXRseSBjaG9vc2UKICAgIGtibG9ja2QuICBBZGQgQGZvcmNlX2tibG9ja2QuCiAgICAKICAg
IEFsbCB0aGUgY3VycmVudCB1c2VycyBhcmUgY29udmVydGVkIHRvIHNwZWNpZnkgJWZhbHNlIGZv
ciB0aGUKICAgIHBhcmFtZXRlciBhbmQgdGhpcyBwYXRjaCBkb2Vzbid0IGludHJvZHVjZSBhbnkg
YmVoYXZpb3IgY2hhbmdlLgogICAgCiAgICBzdGFibGU6IFRoaXMgaXMgcHJlcmVxdWlzaXRlIGZv
ciBmaXhpbmcgaWRlIG9vcHMgY2F1c2VkIGJ5IHRoZSBuZXcKICAgICAgICAgICAgYmxrLWZsdXNo
IGltcGxlbWVudGF0aW9uLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUZWp1biBIZW8gPHRqQGtl
cm5lbC5vcmc+CiAgICBDYzogSmFuIEJldWxpY2ggPEpCZXVsaWNoQG5vdmVsbC5jb20+CiAgICBD
YzogSmFtZXMgQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29t
PgogICAgQ2M6IHN0YWJsZUBrZXJuZWwub3JnCiAgICBTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9l
IDxqYXhib2VAZnVzaW9uaW8uY29tPgoKY29tbWl0IDc2MzQxNGIxMzJhYjlkNmY4ZTIzNjU3YTg3
Y2MxZGM4MjNkMWUzNGUKTWVyZ2U6IDYxNDhhNDcgYzE4Njc5NApBdXRob3I6IEplbnMgQXhib2Ug
PGpheGJvZUBmdXNpb25pby5jb20+CkRhdGU6ICAgRnJpIEZlYiAxMSAxMToxMToyOSAyMDExICsw
MTAwCgogICAgTWVyZ2UgYnJhbmNoICdmb3ItMi42LjM5L2NvcmUnIGludG8gZm9yLW5leHQKICAg
IAogICAgQ29uZmxpY3RzOgogICAgCWJsb2NrL2NmcS1pb3NjaGVkLmMKICAgIAogICAgU2lnbmVk
LW9mZi1ieTogSmVucyBBeGJvZSA8amF4Ym9lQGZ1c2lvbmlvLmNvbT4KCmNvbW1pdCBjMTg2Nzk0
ZGJiNDY2YjQ1Y2Y0MGY5NDJmMmQwOWQ2ZDViNGIwZTQyCkF1dGhvcjogTWlrZSBTbml0emVyIDxz
bml0emVyQHJlZGhhdC5jb20+CkRhdGU6ICAgRnJpIEZlYiAxMSAxMTowODowMCAyMDExICswMTAw
CgogICAgYmxvY2s6IHNoYXJlIHJlcXVlc3QgZmx1c2ggZmllbGRzIHdpdGggIGVsZXZhdG9yX3By
aXZhdGUKICAgIAogICAgRmx1c2ggcmVxdWVzdHMgYXJlIG5ldmVyIHB1dCBvbiB0aGUgSU8gc2No
ZWR1bGVyLiAgQ29udmVydCByZXF1ZXN0CiAgICBzdHJ1Y3R1cmUncyBlbGV2YXRvcl9wcml2YXRl
KiBpbnRvIGFuIGFycmF5IGFuZCBoYXZlIHRoZSBmbHVzaCBmaWVsZHMKICAgIHNoYXJlIGEgdW5p
b24gd2l0aCBpdC4KICAgIAogICAgUmVjbGFpbSB0aGUgc3BhY2UgbG9zdCBpbiAnc3RydWN0IHJl
cXVlc3QnIGJ5IG1vdmluZyAnY29tcGxldGlvbl9kYXRhJwogICAgYmFjayBpbiB0aGUgdW5pb24g
d2l0aCAncmJfbm9kZScuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IE1pa2UgU25pdHplciA8c25p
dHplckByZWRoYXQuY29tPgogICAgQWNrZWQtYnk6IFZpdmVrIEdveWFsIDx2Z295YWxAcmVkaGF0
LmNvbT4KICAgIEFja2VkLWJ5OiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CiAgICBTaWduZWQt
b2ZmLWJ5OiBKZW5zIEF4Ym9lIDxqYXhib2VAZnVzaW9uaW8uY29tPgoKY29tbWl0IDAyYThmMDFi
NWE5ZjM5NmQwMzI3OTc3YWY0YzIzMmQwZjk0YzQ1ZmQKQXV0aG9yOiBKdXN0aW4gVGVyQXZlc3Qg
PHRlcmF2ZXN0QGdvb2dsZS5jb20+CkRhdGU6ICAgV2VkIEZlYiA5IDE0OjIwOjAzIDIwMTEgKzAx
MDAKCiAgICBjZnEtaW9zY2hlZDogRG9uJ3Qgd2FpdCBpZiBxdWV1ZSBhbHJlYWR5IGhhcyByZXF1
ZXN0cy4KICAgIAogICAgQ29tbWl0IDc2NjdhYTA2MzA0MDdiYzA3ZGMzOGRjYzc5ZDI5Y2MwYTY1
NTUzYzEgYWRkZWQgbG9naWMgdG8gd2FpdCBmb3IKICAgIHRoZSBsYXN0IHF1ZXVlIG9mIHRoZSBn
cm91cCB0byBiZWNvbWUgYnVzeSAoaGF2ZSBhdCBsZWFzdCBvbmUgcmVxdWVzdCksCiAgICBzbyB0
aGF0IHRoZSBncm91cCBkb2VzIG5vdCBsb3NlIG91dCBmb3Igbm90IGJlaW5nIGNvbnRpbnVvdXNs
eQogICAgYmFja2xvZ2dlZC4gVGhlIGNvbW1pdCBkaWQgbm90IGNoZWNrIGZvciB0aGUgY29uZGl0
aW9uIHRoYXQgdGhlIGxhc3QKICAgIHF1ZXVlIGFscmVhZHkgaGFzIHNvbWUgcmVxdWVzdHMuIEFz
IGEgcmVzdWx0LCBpZiB0aGUgcXVldWUgYWxyZWFkeSBoYXMKICAgIHJlcXVlc3RzLCB3YWl0X2J1
c3kgaXMgc2V0LiBMYXRlciBvbiwgY2ZxX3NlbGVjdF9xdWV1ZSgpIGNoZWNrcyB0aGUKICAgIGZs
YWcsIGFuZCBkZWNpZGVzIHRoYXQgc2luY2UgdGhlIHF1ZXVlIGhhcyBhIHJlcXVlc3Qgbm93IGFu
ZCB3YWl0X2J1c3kKICAgIGlzIHNldCwgdGhlIHF1ZXVlIGlzIGV4cGlyZWQuICBUaGlzIHJlc3Vs
dHMgaW4gZWFybHkgZXhwaXJhdGlvbiBvZiB0aGUKICAgIHF1ZXVlLgogICAgCiAgICBUaGlzIHBh
dGNoIGZpeGVzIHRoZSBwcm9ibGVtIGJ5IGFkZGluZyBhIGNoZWNrIHRvIHNlZSBpZiBxdWV1ZSBh
bHJlYWR5CiAgICBoYXMgcmVxdWVzdHMuIElmIGl0IGRvZXMsIHdhaXRfYnVzeSBpcyBub3Qgc2V0
LiBBcyBhIHJlc3VsdCwgdGltZSBzbGljZXMKICAgIGRvIG5vdCBleHBpcmUgZWFybHkuCiAgICAK
ICAgIFRoZSBxdWV1ZXMgd2l0aCBtb3JlIHRoYW4gb25lIHJlcXVlc3QgYXJlIHVzdWFsbHkgYnVm
ZmVyZWQgd3JpdGVycy4KICAgIFRlc3Rpbmcgc2hvd3MgaW1wcm92ZW1lbnQgaW4gaXNvbGF0aW9u
IGJldHdlZW4gYnVmZmVyZWQgd3JpdGVycy4KICAgIAogICAgQ2M6IHN0YWJsZUBrZXJuZWwub3Jn
CiAgICBTaWduZWQtb2ZmLWJ5OiBKdXN0aW4gVGVyQXZlc3QgPHRlcmF2ZXN0QGdvb2dsZS5jb20+
CiAgICBSZXZpZXdlZC1ieTogR3VpIEppYW5mZW5nIDxndWlqaWFuZmVuZ0Bjbi5mdWppdHN1LmNv
bT4KICAgIEFja2VkLWJ5OiBWaXZlayBHb3lhbCA8dmdveWFsQHJlZGhhdC5jb20+CiAgICBTaWdu
ZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxqYXhib2VAZnVzaW9uaW8uY29tPgo=
--00163649a965f6800c049de2e351--
