Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0EGNC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:02:28 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:36720 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751790Ab0EGNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:02:26 -0400
X-Greylist: delayed 1280 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 09:02:26 EDT
X-Panda: scanned!
X-Spam-Summary: 2,-0.0526316,0,300d89ec71776133,d41d8cd98f00b204,rostedt@goodmis.org,fweisbec@gmail.com:linux-kernel@vger.kernel.org:mingo@elte.hu:akpm@linux-foundation.org:tglx@linutronix.de:peterz@infradead.org:acme@redhat.com:compudj@krystal.dyndns.org:laijs@cn.fujitsu.com:lizf@cn.fujitsu.com:mhiramat@redhat.com:hch@lst.de,RULES_HIT:46:152:355:379:601:800:960:968:973:988:989:1260:1313:1314:1345:1359:1437:1516:1518:1534:1542:1575:1594:1676:1711:1730:1747:1764:1766:1792:1963:2198:2199:2378:2393:2553:2559:2562:2693:3354:3834:3865:3866:3867:3868:3869:3870:3871:3872:3874:4321:4362:4560:5007:6119:6261:7514:7576:7875:7903:8603:9040:10004:10016,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:1:0
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Filterd-Recvd-Size: 4781
X-User-Agent: K-9 Mail for Android
In-Reply-To: <20100507042025.GC8069@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere>
Content-Type: multipart/mixed; boundary="----4XISSEOAESISOCN3CFSBH589QU4HOE"
MIME-Version: 1.0
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_3/9_-_v2=5D=5BRFC=5D_tracing?= =?US-ASCII?Q?=3A_Remove_per_event_trace=09registering?=
From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 07 May 2010 08:42:30 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Message-ID: <bddfebe8-61b9-4fb7-b7e5-5b0664f2b47c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------4XISSEOAESISOCN3CFSBH589QU4HOE
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

CgoiRnJlZGVyaWMgV2Vpc2JlY2tlciIgPGZ3ZWlzYmVjQGdtYWlsLmNvbT4gd3JvdGU6Cgo+T24g
TW9uLCBNYXkgMDMsIDIwMTAgYXQgMTE6NDA6NDhQTSAtMDQwMCwgU3RldmVuIFJvc3RlZHQgd3Jv
dGU6Cj4+IEZyb206IFN0ZXZlbiBSb3N0ZWR0IDxzcm9zdGVkdEByZWRoYXQuY29tPgo+PiAKPj4g
VGhpcyBwYXRjaCByZW1vdmVzIHRoZSByZWdpc3RlciBmdW5jdGlvbnMgb2YgVFJBQ0VfRVZFTlQo
KSB0byBlbmFibGUKPj4gYW5kIGRpc2FibGUgdHJhY2Vwb2ludHMuIFRoZSByZWdpc3RlcmluZyBv
ZiBhIGV2ZW50IGlzIG5vdyBkb3duCj4+IGRpcmVjdGx5IGluIHRoZSB0cmFjZV9ldmVudHMuYyBm
aWxlLiBUaGUgdHJhY2Vwb2ludF9wcm9iZV9yZWdpc3RlcigpCj4+IGlzIG5vdyBjYWxsZWQgZGly
ZWN0bHkuCj4+IAo+PiBUaGUgcHJvdG90eXBlcyBhcmUgbm8gbG9uZ2VyIHR5cGUgY2hlY2tlZCwg
YnV0IHRoaXMgc2hvdWxkIG5vdCBiZQo+PiBhbiBpc3N1ZSBzaW5jZSB0aGUgdHJhY2Vwb2ludHMg
YXJlIGNyZWF0ZWQgYXV0b21hdGljYWxseSBieSB0aGUKPj4gbWFjcm9zLiBJZiBhIHByb3RvdHlw
ZSBpcyBpbmNvcnJlY3QgaW4gdGhlIFRSQUNFX0VWRU5UKCkgbWFjcm8sIHRoZW4KPj4gb3RoZXIg
bWFjcm9zIHdpbGwgY2F0Y2ggaXQuCj4KPgo+Cj5BZ3JlZWQuIFR5cGVjaGVja2luZyBtYXR0ZXJz
IGZvciBodW1hbiBjb2RlIGJ1dCBub3QgaW4gdGhpcyBjb250ZXh0Lgo+Q29uc2lkZXJpbmcgdGhh
dCB0aGUgdHJhY2Vwb2ludCBhbmQgdGhlIHByb2JlIGFyZSBjcmVhdGVkIGJ5IHRoZSBzYW1lCj5D
UFAgY29kZSwgYnVncyB3aWxsIGJlIHRyYWNrZWQgZG93biBxdWlja2x5IGFuZCBsb2NhdGVkIHRv
IGEgc2luZ2xlCj5wbGFjZS4KPgo+Cj4KPgo+PiAKPj4gVGhlIHRyYWNlX2V2ZW50X2NsYXNzIHN0
cnVjdHVyZSBub3cgaG9sZHMgdGhlIHByb2JlcyB0byBiZSBjYWxsZWQKPj4gYnkgdGhlIGNhbGxi
YWNrcy4gVGhpcyByZW1vdmVzIG5lZWRpbmcgdG8gaGF2ZSBlYWNoIGV2ZW50IGhhdmUKPj4gYSBz
ZXBhcmF0ZSBwb2ludGVyIGZvciB0aGUgcHJvYmUuCj4+IAo+PiBUbyBoYW5kbGUga3Byb2JlcyBh
bmQgc3lzY2FsbHMsIHNpbmNlIHRoZXkgcmVnaXN0ZXIgcHJvYmVzIGluIGEKPj4gZGlmZmVyZW50
IG1hbm5lciwgYSAicmVnIiBmaWVsZCBpcyBhZGRlZCB0byB0aGUgZnRyYWNlX2V2ZW50X2NsYXNz
Cj4+IHN0cnVjdHVyZS4gSWYgdGhlICJyZWciIGZpZWxkIGlzIGFzc2lnbmVkLCB0aGVuIGl0IHdp
bGwgYmUgY2FsbGVkIGZvcgo+PiBlbmFibGluZyBhbmQgZGlzYWJsaW5nIG9mIHRoZSBwcm9iZSBm
b3IgZWl0aGVyIGZ0cmFjZSBvciBwZXJmLiBUbyBsZXQKPj4gdGhlIHJlZyBmdW5jdGlvbiBrbm93
IHdoYXQgaXMgaGFwcGVuaW5nLCBhIG5ldyBlbnVtICh0cmFjZV9yZWcpIGlzCj4+IGNyZWF0ZWQg
dGhhdCBoYXMgdGhlIHR5cGUgb2YgY29udHJvbCB0aGF0IGlzIG5lZWRlZC4KPj4gCj4+IFdpdGgg
dGhpcyBuZXcgcmV3b3JrLCB0aGUgODIga2VybmVsIGV2ZW50cyBhbmQgNjE2IHN5c2NhbGwgZXZl
bnRzCj4+IGhhcyB0aGVpciBmb290cHJpbnQgZHJhbWF0aWNhbGx5IGxvd2VyZWQ6Cj4+IAo+PiAg
ICB0ZXh0CSAgIGRhdGEJICAgIGJzcwkgICAgZGVjCSAgICBoZXgJZmlsZW5hbWUKPj4gNTc4ODE4
NgkxMzM3MjUyCTkzNTE1OTIJMTY0NzcwMzAJIGZiNmI2Ngl2bWxpbnV4Lm9yaWcKPj4gNTc5MjI4
MgkxMzMzNzk2CTkzNTE1OTIJMTY0Nzc2NzAJIGZiNmRlNgl2bWxpbnV4LmNsYXNzCj4+IDU3OTM0
NDgJMTMzMzc4MAk5MzUxNTkyCTE2NDc4ODIwCSBmYjcyNjQJdm1saW51eC50cmFjZXBvaW50Cj4+
IDU3OTY5MjYJMTMzNzc0OAk5MzUxNTkyCTE2NDg2MjY2CSBmYjhmN2EJdm1saW51eC5kYXRhCj4+
IDU3NzQzMTYJMTMwNjU4MAk5MzUxNTkyCTE2NDMyNDg4CSBmYWJkNjgJdm1saW51eC5yZWdzCj4+
IAo+PiBUaGUgc2l6ZSB3ZW50IGZyb20gMTY0NzcwMzAgdG8gMTY0MzI0ODgsIHRoYXQncyBhIHRv
dGFsIG9mIDQ0Swo+PiBpbiBzYXZpbmdzLiBXaXRoIHRyYWNlcG9pbnRzIGJlaW5nIGNvbnRpbnVv
dXNseSBhZGRlZCwgdGhpcyBpcwo+PiBjcml0aWNhbCB0aGF0IHRoZSBmb290cHJpbnQgYmVjb21l
cyBtaW5pbWFsLgo+PiAKPj4gdjI6IENoYW5nZWQgdGhlIGNhbGxiYWNrIHByb2JlcyB0byBwYXNz
IHZvaWQgKiBhbmQgdHlwZWNhc3QgdGhlCj4+ICAgICB2YWx1ZSB3aXRoaW4gdGhlIGZ1bmN0aW9u
Lgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5v
cmc+Cj4KPgo+Cj5WZXJ5IG5pY2UhIQo+Cj5BY2tlZC1ieTogRnJlZGVyaWMgV2Vpc2JlY2tlciA8
ZndlaXNiZWNAZ21haWwuY29tPgo+CgpUaGFua3MhIAoKLS0gU3RldmUgCgoKLS0gClNlbnQgZnJv
bSBteSBBbmRyb2lkIHBob25lIHdpdGggSy05IE1haWwuIFBsZWFzZSBleGN1c2UgbXkgYnJldml0
eS4=

------4XISSEOAESISOCN3CFSBH589QU4HOE--

