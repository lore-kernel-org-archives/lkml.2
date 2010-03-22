Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0CVHpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:45:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62607 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0CVHo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DY6VZnZ2xOo1rnoabBNn9AObCox40/jVhVOTBDOA2lL57W1/w0LIV9MXwNmh34Beue
         OE9xXsZihIG5gVCLG//BQ9ejp0dneEktZp0kMV2pFLthqS8lZZFLHsSLK5cYBO1Njh3O
         DBHr2mFChYltEcqs9Tc9779Bxl2t7SB9LvYEA=
MIME-Version: 1.0
In-Reply-To: <20100322063747.GF31621@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com> 
	<20100309175107.GB23378@core.coreip.homeip.net> <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com> 
	<20100309181037.GB19814@core.coreip.homeip.net> <8bd0f97a1003091013q565f8b1bse66b48d9c9a25600@mail.gmail.com> 
	<20100322063747.GF31621@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Mar 2010 03:44:38 -0400
Message-ID: <8bd0f97a1003220044n65e2d543ubc831810c0d3da97@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Song, Barry" <Barry.Song@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: multipart/mixed; boundary=000e0cd23d48ae94ee04825edf65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd23d48ae94ee04825edf65
Content-Type: text/plain; charset=UTF-8

On Mon, Mar 22, 2010 at 02:37, Dmitry Torokhov wrote:
> On Tue, Mar 09, 2010 at 01:13:34PM -0500, Mike Frysinger wrote:
>> On Tue, Mar 9, 2010 at 13:10, Dmitry Torokhov wrote:
>> > On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
>> >> the AD714x is not an accelerometer, it's a capacitance touch sensor
>> >
>> > OK, will dig it up.
>>
>> thanks
>
> Mike, could you please take a look at mny 'next' branch and give the
> version there a try - I made a couple of small changes before
> applying...

changes look ok to me, and it seems to build fine.  maybe Barry can
give it a quick test to make sure it still probes/works, but i dont
see anything to suggest it wouldnt ...

if you're doing cosmetic fixes, i'd suggest squashing the attached into it too.
-mike

--000e0cd23d48ae94ee04825edf65
Content-Type: application/octet-stream; name="ad714x-comments.patch"
Content-Disposition: attachment; filename="ad714x-comments.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g72z14n60

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQvbWlzYy9hZDcxNHguYyBiL2RyaXZlcnMvaW5wdXQv
bWlzYy9hZDcxNHguYwppbmRleCBlZDYzODFhLi5mOGM0ZTQ1IDEwMDY0NAotLS0gYS9kcml2ZXJz
L2lucHV0L21pc2MvYWQ3MTR4LmMKKysrIGIvZHJpdmVycy9pbnB1dC9taXNjL2FkNzE0eC5jCkBA
IC0yMzQsNyArMjM0LDYgQEAgc3RhdGljIGludCBhZDcxNHhfY2FsX2Fic19wb3Moc3RydWN0IGFk
NzE0eF9jaGlwICphZDcxNHgsCiAJcmV0dXJuIChtYXhfY29vcmQgLyAoZW5kX3N0YWdlIC0gc3Rh
cnRfc3RhZ2UpKSAqIGFfcGFyYW0gLyBiX3BhcmFtOwogfQogCi0KIC8qCiAgKiBPbmUgYnV0dG9u
IGNhbiBjb25uZWN0IHRvIG11bHRpIHBvc2l0aXZlIGFuZCBuZWdhdGl2ZSBvZiBDRENzCiAgKiBN
dWx0aS1idXR0b25zIGNhbiBjb25uZWN0IHRvIHNhbWUgcG9zaXRpdmUvbmVnYXRpdmUgb2Ygb25l
IENEQwpAQCAtNDI2LDcgKzQyNSw4IEBAIHN0YXRpYyB2b2lkIGFkNzE0eF9zbGlkZXJfc3RhdGVf
bWFjaGluZShzdHJ1Y3QgYWQ3MTR4X2NoaXAgKmFkNzE0eCwgaW50IGlkeCkKIAl9CiB9CiAKLS8q
IFdoZW4gdGhlIHNjcm9sbCB3aGVlbCBpcyBhY3RpdmF0ZWQsIHdlIGNvbXB1dGUgdGhlIGFic29s
dXRlIHBvc2l0aW9uIGJhc2VkCisvKgorICogV2hlbiB0aGUgc2Nyb2xsIHdoZWVsIGlzIGFjdGl2
YXRlZCwgd2UgY29tcHV0ZSB0aGUgYWJzb2x1dGUgcG9zaXRpb24gYmFzZWQKICAqIG9uIHRoZSBz
ZW5zb3IgdmFsdWVzLiBUbyBjYWxjdWxhdGUgdGhlIHBvc2l0aW9uLCB3ZSBmaXJzdCBkZXRlcm1p
bmUgdGhlCiAgKiBzZW5zb3IgdGhhdCBoYXMgdGhlIGdyZWF0ZXN0IHJlc3BvbnNlIGFtb25nIHRo
ZSA4IHNlbnNvcnMgdGhhdCBjb25zdGl0dXRlcwogICogdGhlIHNjcm9sbHdoZWVsLiBUaGVuIHdl
IGRldGVybWluZWQgdGhlIDIgc2Vuc29ycyBvbiBlaXRoZXIgc2lkZXMgb2YgdGhlCkBAIC0xMDA1
LDcgKzEwMDUsNyBAQCBzdGF0aWMgdm9pZCBhZDcxNHhfaHdfaW5pdChzdHJ1Y3QgYWQ3MTR4X2No
aXAgKmFkNzE0eCkKIAl1bnNpZ25lZCBzaG9ydCByZWdfYmFzZTsKIAl1bnNpZ25lZCBzaG9ydCBk
YXRhOwogCi0JLyogY29uZmlndXJhdGlvbiBDREMgYW5kIGludGVycnVwdHMqLworCS8qIGNvbmZp
Z3VyYXRpb24gQ0RDIGFuZCBpbnRlcnJ1cHRzICovCiAKIAlmb3IgKGkgPSAwOyBpIDwgU1RBR0Vf
TlVNOyBpKyspIHsKIAkJcmVnX2Jhc2UgPSBBRDcxNFhfU1RBR0VDRkdfUkVHICsgaSAqIFNUQUdF
X0NGR1JFR19OVU07Cg==
--000e0cd23d48ae94ee04825edf65--
