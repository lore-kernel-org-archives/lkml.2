Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2ANPUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:20:01 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44669 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2ANPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:19:58 -0500
To: luto@amacapital.net, jamie@shareable.org
From: Eric Paris <eparis@redhat.com>
Cc: torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, oleg@redhat.com,
        wad@chromium.org, linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net
Date: Sat, 14 Jan 2012 10:17:52 -0500 (EST)
X-Mailer: TouchDown
X-Mailer: Zimbra 7.1.2_GA_3268 (MobileSync - TouchDown(MSRPC)/7.1.00012/)
MIME-Version: 1.0
Subject: =?utf-8?B?UmU6IFtQQVRDSF0gQWRkIFBSX3tHRVQsU0VUfV9OT19ORVdfUFJJVlMgdG8gcHJldmVudCBleGVj?=
 =?utf-8?B?dmUgZnJvbSBncmFudGluZyBwcml2cw==?=
Content-Type: multipart/mixed;boundary="__1326554283773TOUCHDOWN_BOUNDARY__"
Message-ID: <300903415.833492.1326554271998.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--__1326554283773TOUCHDOWN_BOUNDARY__
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

-----Original Message-----=0D=0AFrom: Jamie Lokier [jamie@shareable.org]=0D=0A=
Received: Saturday, 14 Jan 2012, 8:56am=0D=0ATo: Andy Lutomirski [luto@amaca=
pital.net]=0D=0ACC: Linus Torvalds [torvalds@linux-foundation.org]; Alan Cox=
 [alan@lxorguk.ukuu.org.uk]; Oleg Nesterov [oleg@redhat.com]; Will Drewry [w=
ad@chromium.org]; linux-kernel@vger.kernel.org, keescook@chromium.org, john.=
johansen@canonical.com, serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.co=
m, pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org, segoon@openwall.co=
m, rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com, avi@redhat=
.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu, mingo@e=
lte.hu, akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com, =
amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.d=
e, dhowells@redhat.com, daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.or=
g, linux-security-module@vger.kernel.org, olofj@chromium.org, mhalcrow@googl=
e.com, dlaor@redhat.com, corbet@lwn.net=0D=0ASubject: Re: [PATCH] Add PR_{GE=
T,SET}_NO_NEW_PRIVS to prevent execve from granting privs=0D=0A=0D=0AAndy Lu=
tomirski wrote:=0D=0A=0D=0A> Is the current exec_no_trans check enough for y=
ou?  With my patch,=0D=0A> selinux can already block the execve if it wants.=
  (The policy is the=0D=0A> same as it would be if a program explicitly aske=
d to run the new=0D=0A> executable with an unchanged security context.)  I'd=
 be happy to fail=0D=0A> the exec in AppArmor, and then maybe AppArmor will =
change its mind=0D=0A> if/when users get annoyed :)=0D=0A=0D=0ADoes SELinux =
block if userspace does exec entirely in userspace using=0D=0Ammap() and not=
 execve()?  If not, why is execve() allowed to be different?=0D=0A=0D=0AYes,=
 we do (or can, and usually do in policy)=0D=0A

--__1326554283773TOUCHDOWN_BOUNDARY__--
