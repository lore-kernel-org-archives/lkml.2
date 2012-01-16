Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2APClg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:41:36 -0500
Received: from nm17-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.21]:41946
	"HELO nm17-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753127Ab2APClf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:41:35 -0500
X-Yahoo-Newman-Id: 416593.8850.bm@smtp108.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QEXHXSYVM1kWGPdtABn8B1MKiCp3OwcfKfxETKneJgTSZKt
 3cMC9KkTRMYu0imnIhUp779_ft9awLvVBFsxTjaDrVFj0LbaHekE3nHeL6_n
 GrGtxj_KqHrN88KJdylNDJV32_8Rts33SxqP55824DHJ9wlYBx2cE0g02bbG
 OOlshJZ_8YRn1lXuMCS36HCEAEUDCKkhxpvXtScB0FCaAkrvbKCJrU847NRo
 5R3Vp099.RRIGKGmV5v2oemT.bmcshI4VV2Fzj2blLyKR5j3b311Kc4yO8ru
 66dmYE2lwvxIQpVX0fuhwLalbPEK_E4oZqpmg6yyIjDvwVNzL1ip1XFk1p5_
 R1ZMjdJIhONzS4SXarQ0L584ipTBvlQXKV1UA2K4Ks39yp9lPlbXExvHR34R
 KWM.H9rgtS5dHoATouWXHSjCVl5.dyUpG4s22knsnR2LBY_8pQZwqDUD68Fe
 Lc3nsDSrCGYxu4V1.Ud3wqyENROV.sVP1QtGsJA2kMIlyh9bhai69rZOBxIV
 gAsHb82zAhbsrF_9MiybIK9dtfpDErhLZzwd5j_9N_WX1IdNz
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F138E57.6030007@schaufler-ca.com>
Date: Sun, 15 Jan 2012 18:41:27 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
References: <1326411506-16894-1-git-send-email-wad@chromium.org> <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com> <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com> <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com> <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com> <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com> <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com> <4F133423.5070007@schaufler-ca.com> <CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com> <4F1345DB.8040303@schaufler-ca.com> <CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
In-Reply-To: <CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2012 2:07 PM, Andrew Lutomirski wrote:
> On Sun, Jan 15, 2012 at 1:32 PM, Casey Schaufler<casey@schaufler-ca.com>  wrote:
>> On 1/15/2012 12:59 PM, Andrew Lutomirski wrote:
>>> On Sun, Jan 15, 2012 at 12:16 PM, Casey Schaufler
>>> <casey@schaufler-ca.com>    wrote:
>>>> On 1/14/2012 12:22 PM, Linus Torvalds wrote:
>>>>> And yes, I really seriously do believe that is both safer and simpler
>>>>> than some model that says "you can drop stuff", and then you have to
>>>>> start making up rules for what "dropping" means.
>>>>>
>>>>> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
>>>>> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
>>>>> that no, we should not even allow that. It's simply all too "subtle".
>>>>
>>>> I am casting my two cents worth behind Linus. Dropping
>>>> privilege can be every bit as dangerous as granting privilege
>>>> in the real world of atrocious user land code. Especially in
>>>> the case of security policy enforcing user land code.
>>> Can you think of *any* plausible attack that is possible with my patch
>>> (i.e. no_new_privs allows setuid, setresuid, and capset) that would be
>>> prevented or even mitigated if I blocked those syscalls?  I can't.
>>> (The sendmail-style attack is impossible with no_new_privs.)
>>
>> I am notoriously bad at coming up with this sort of example.
>> I will try, I may not hit the mark, but it should be close.
>>
>> The application is running with saved uid != euid when
>> no-new-privs is set. It execs a new binary, which keeps
>> the saved and effective uids. The program calls setreuid,
>> which succeeds. It opens the saved userid's files.
> If you don't trust that binary, then why are you execing it with saved
> uid != euid in the first place?

If I could trust the binary I wouldn't need your no_new_privs
semantics in the first place. Do you have any idea how big the
chrome browser binary is? You can't link it on a 32bit machine
it uses so much address space. On top of that, most modern
applications are compositions of scripts and interpreters built
on top of multiple layers of middleware. Of course I don't trust
the binary!

> If you are setting no_new_privs, then
> you are new code and should have at least some basic awareness of the
> semantics.

It's not the program setting no_new_privs that I'm worried about.
It's the nth descendant of that program and its ancestors that are
going to do screwy things.

> The exact same "exploit" is possible if you have
> CAP_DAC_OVERRIDE with either no_new_privs semantics -- if you have a
> privilege and you run untrusted code, then you had better remove that
> privilege somehow for the untrusted code.

Yes, and my very own name is engraved on the security wall of shame
for the classic sendmail capabilities exploit. Don't think for a
minute that something won't get done just because its obviously
inappropriate.

> IOW, *drop privileges if you are a sandbox*.  Otherwise you're screwed
> with or without no_new_privs.
>
>
> Another way of saying this is: no_new_privs is not a sandbox.  It's
> just a way to make it safe for sandboxes and other such weird things
> processes can do to themselves safe across execve.  If you want a
> sandbox, use seccomp mode 2, which will require you to set
> no_new_privs.
>
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

